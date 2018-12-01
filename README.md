# Backup Scripts

Inspired by https://lists.nongnu.org/archive/html/rdiff-backup-users/2013-06/msg00014.html.

## Installation Instructions

### Linux

```
sudo apt-get install rdiff-backup
```

### Windows

1. Download [cwRsync](https://www.itefix.net/content/cwrsync-free-edition).
2. Unpack and copy `bin` to `windows`.
3. Create `windows/home/<your username>/.ssh/id_rsa`:
   * Add your private key
   * Change the file's access rights: only the current user may have access.
4. Copy `config.cmd.example` to `config.cmd` and modify according to your configuration.
5. Run `sync.cmd`
