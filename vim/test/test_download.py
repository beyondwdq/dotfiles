#!/usr/bin/env python
# -*- coding: utf-8 -*-

import unittest
from mock import Mock, mock_open, patch, call
from contextlib import nested
import download


class TestDownload(unittest.TestCase):

    def test_get_command_str_update_False(self):
        cmd = download.get_command_string('git', update=False)
        self.assertEqual(cmd, ['git', 'clone'])

    def test_get_command_str_update_True(self):
        cmd = download.get_command_string('git', update=True)
        self.assertEqual(cmd, ['git', 'pull'])

    def test_get_dirname_has_git_suffix(self):
        url = 'git://github.com/tpope/vim-pathogen.git'
        dirname = download.get_dirname(url)
        self.assertEqual(dirname, 'vim-pathogen')

    def test_get_dirname_no_git_suffix(self):
        url = 'https://github.com/vim-scripts/a.vim'
        dirname = download.get_dirname(url)
        self.assertEqual(dirname, 'a.vim')

    def test_parse_line_no_cmd(self):
        line = 'git://github.com/tpope/vim-pathogen.git'
        cmd, url = download.parse_line(line)
        self.assertEqual(cmd, 'git')
        self.assertEqual(url, 'git://github.com/tpope/vim-pathogen.git')

    def test_parse_line_with_cmd(self):
        line = 'git https://github.com/tpope/vim-pathogen.git'
        cmd, url = download.parse_line(line)
        self.assertEqual(cmd, 'git')
        self.assertEqual(url, 'https://github.com/tpope/vim-pathogen.git')

    def test_load_lines(self):
        lines = ['https://github.com/tpope/vim-pathogen.git',
                 '',
                 '#https://github.com/scrooloose/syntastic.git',
                 ]
        m = mock_open(read_data='\n'.join(lines))
        m.return_value.__iter__ = lambda x: iter(x.readline, '')
        with patch('__builtin__.open', m):
            lines = list(download.load_lines('dummyfile'))
            m.assert_called_with('dummyfile', 'r')
            expected = ['https://github.com/tpope/vim-pathogen.git']
            self.assertEqual(lines, expected)

    def test_get_command_for_url_git(self):
        url = 'git://github.com/tpope/vim-pathogen.git'
        cmd = download.get_command_for_url(url)
        self.assertEqual(cmd, 'git')

    def test_get_command_for_url_git_https(self):
        url = 'https://github.com/tpope/vim-pathogen.git'
        cmd = download.get_command_for_url(url)
        self.assertEqual(cmd, 'git')

    def test_get_command_for_url_hg(self):
        url = 'hg://github.com/tpope/vim-pathogen'
        cmd = download.get_command_for_url(url)
        self.assertEqual(cmd, 'hg')

    def test_get_command_for_url_non_specified(self):
        url = 'https://github.com/tpope/vim-pathogen'
        cmd = download.get_command_for_url(url)
        self.assertEqual(cmd, 'git')

    def test_run_update_update_False(self):
        lines = ['https://github.com/tpope/vim-pathogen.git',
                 'https://github.com/vim-scripts/a.vim',
                 ]
        def if_exists(name):
            return name == 'a.vim'

        mock_subproc = Mock()
        patch_lines = patch('download.load_lines', return_value=iter(lines))
        patch_subproc = patch('download.subprocess.call', mock_subproc)
        patch_exists = patch('download.bundle_exists', if_exists)

        with nested(patch_lines, patch_subproc, patch_exists):
            download.run(update=False)
            mock_subproc.assert_called_with(['git', 'clone', lines[0]])

    def test_run_update_update_True(self):
        lines = ['https://github.com/tpope/vim-pathogen.git',
                 'https://github.com/vim-scripts/a.vim',
                 ]
        def if_exists(name):
            return name == 'a.vim'

        mock_subproc = Mock()
        patch_lines = patch('download.load_lines', return_value=iter(lines))
        patch_subproc = patch('download.subprocess.call', mock_subproc)
        patch_exists = patch('download.bundle_exists', if_exists)

        clone_call = call(['git', 'clone', lines[0]])
        update_call = call(['git', 'pull',], cwd='a.vim')

        with nested(patch_lines, patch_subproc, patch_exists):
            download.run(update=True)
            mock_subproc.assert_has_calls([clone_call, update_call])

if __name__ == '__main__':
    unittest.main()
