<h1 align="center">downsample</h1>

## Overview

`downsample.sh` is a simple
[POSIX](https://pubs.opengroup.org/onlinepubs/9699919799/)-compliant
shell script that resamples 24-bit FLAC files to 16-bit using the
appropriate sampling rate scaling for each file.

## Appropriate sampling rate scaling?

Downsampling lossless files to a common multiple may minimize the chance
of introducing various artifacts during the conversion. For example, a
sampling rate of 88.2 kHz shall be converted to 44.1 kHz, *not* 48 kHz.

## Usage

```sh
$ ./downsample.sh <DIR> [<DIR2>..]
```

## Examples

Suppose we have the following directory structure:

<details>
  <summary><i>directory structure before downsampling</i></summary>
<pre><code>music/
└── experimental/
    ├── musique concrete/
    │   └── Brume/
    │       └── 2012 - Fractisum/
    │           ├── 01 - Fractisum (Part 1).flac
    │           ├── 02 - Fractisum (Part 2).flac
    │           ├── cover.jpg
    │           └── lineage.txt
    └── noise/
        └── Masonna/
            └── 1991 - Split w. Violent Onsen Geisha/
                ├── 01 - Violent Onsen Geisha - Ultra Psychotic Piss Drunk Bunny Girl!.flac
                ├── 02 - Violent Onsen Geisha - Cock Guillotine 1965.flac
                ├── <...>
                ├── 12 - Masonna - Key.asasggkjkieeee.flac
                ├── 13 - Masonna - Sax.asqqqrtefdhkgjriukhvjbmosfjiejp.flac
                ├── cover.jpg
                └── lineage.txt</code></pre>
</details>

If we were to downsample all these files, we would use either

```sh
$ ./downsample.sh music
```

or

```sh
$ ./downsample.sh music/experimental
```

or even

```sh
$ ./downsample.sh music/experimental/{noise,musique\ concrete}
```

and any of the three commands would produce the desired output. Now,
let’s take a look at the directory structure after running the script:

<details>
  <summary><i>directory structure after downsampling</i></summary>
<pre><code>music/
└── experimental/
    ├── musique concrete/
    │   └── Brume/
    │       └── 2012 - Fractisum/
    │           ├── <strong>resampled-16-44/</strong>
    │           │   ├── 01 - Fractisum (Part 1).flac
    │           │   └── 02 - Fractisum (Part 2).flac
    │           ├── 01 - Fractisum (Part 1).flac
    │           ├── 02 - Fractisum (Part 2).flac
    │           ├── cover.jpg
    │           └── lineage.txt
    └── noise/
        └── Masonna/
            └── 1991 - Split w. Violent Onsen Geisha/
                ├── <strong>resampled-16-48/</strong>
                │   ├── 01 - Violent Onsen Geisha - Ultra Psychotic Piss Drunk Bunny Girl!.flac
                │   ├── 02 - Violent Onsen Geisha - Cock Guillotine 1965.flac
                │   ├── <...>
                │   ├── 12 - Masonna - Key.asasggkjkieeee.flac
                │   └── 13 - Masonna - Sax.asqqqrtefdhkgjriukhvjbmosfjiejp.flac
                ├── 01 - Violent Onsen Geisha - Ultra Psychotic Piss Drunk Bunny Girl!.flac
                ├── 02 - Violent Onsen Geisha - Cock Guillotine 1965.flac
                ├── <...>
                ├── 12 - Masonna - Key.asasggkjkieeee.flac
                ├── 13 - Masonna - Sax.asqqqrtefdhkgjriukhvjbmosfjiejp.flac
                ├── cover.jpg
                └── lineage.txt</code></pre>
</details>

## Dependencies

`sox` is the only dependency here. On Debian-based distros, the package
can be installed by running the following command:

```sh
$ sudo apt-get install sox
```
