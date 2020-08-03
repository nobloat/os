/*
 * mkbootimg/lang.c
 *
 * Copyright (C) 2017 - 2020 bzt (bztsrc@gitlab)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This file is part of the BOOTBOOT Protocol package.
 * @brief Multilanguage support
 *
 */

#include "lang.h"

/**
 * Translations
 */
char *dict[NUMLANGS][NUMTEXTS + 1] = {
    {
        "en",

        "memory allocation error",
        "unable to read initrd image",
        "initrd not specified in json",
        "initrd type not specified in json",
        "invalid initrd type",
        "Accepted values",
        "unable to read BOOTBOOT configuration from",
        "BOOTBOOT configuration file is bigger than 4095 bytes",
        "partitions array or boot partition's type not specified in json",
        "boot partition's size not specified in json",
        "invalid architecture in kernel",
        "more than one loadable segment in kernel",
        "entry point is not in text segment",
        "invalid kernel executable format. ELF64 or PE32+ only",
        "not in the higher half top -1G",
        "not %d bytes aligned",
        "not page aligned",
        "segment is bigger than 16M",
        "unable to write",
        "unable to locate kernel",
        "unable to read kernel from",
        "unable to read configuration json from",
        "doesn't have a valid type",
        "or any non-zero GUID in the form",
        "doesn't have a name",
        "unable to read partition image",
        "stage2 is not 2048 byte sector aligned",
        "constructed file system is bigger than partition size",
        "size must be specified",
        "file too big",
        "too many entries in directory",
        "must use valid static addresses",
        "valid dynamic addresses",
        "Validates ELF or PE executables for being BOOTBOOT compatible, otherwise",
        "creates a bootable hybrid image for your hobby OS or Option ROM image",
        "Usage",
        "configuration json",
        "output disk image name",
        "Examples",
        "writing",
        "saved"
    },
    {
        "hu",

        "memória foglalási hiba",
        "nem lehet az initrd képet beolvasni",
        "initrd nincs megadva a json-ben",
        "initrd type nincs megadva a json-ben",
        "érvénytelen initrd type",
        "Lehetséges értékek",
        "nem tudom beolvasni a BOOTBOOT konfigurációt innen",
        "a BOOTBOOT konfiguráció több, mint 4095 bájt",
        "partitions tömb vagy a boot partíció type-ja nincs megadva a json-ben",
        "a boot partíció mérete (size) nincs megadva a json-ben",
        "érvénytelen kernel architektúra",
        "több, mint egy betöltendő kernel szegmens",
        "belépési pont nem a kódszegmensen belülre mutat",
        "érvénytelen kernel futtatható. ELF64 vagy PE32+ lehet csak",
        "nincs a felső memória -1G tartományában",
        "nem %d bájtra igazított",
        "nincs laphatárra igazítva",
        "szegmens nagyobb, mint 16M",
        "nem tudom írni",
        "nem találom a kernelt benne",
        "nem tudom betölteni a kernelt innen",
        "nem tudom beolvasni a konfigurációs json-t innen",
        "nincs érvényes type típusa",
        "vagy bármilyen nem csupa nulla GUID ilyen formátumban",
        "nincs név megadva a name-ben",
        "nem tudom a partíciós képet beolvasni",
        "stage2 nincs 2048 bájtos szektorhatárra igazítva",
        "az összeállított fájlrendszer nagyobb, mint a megadott partíció méret a size-ban",
        "a méretet kötelező megadni a size-ban",
        "túl nagy fájl",
        "túl sok könyvtárbejegyzés",
        "helyes statikus címeket kell használnia",
        "érvényes dinamikus címek",
        "Ellenőrzi, hogy az ELF vagy PE futtatható BOOTBOOT kompatíbilis-e, illetve",
        "hibrid indító lemez képet generál a hobbi OS-edhez vagy Option ROM képet",
        "Használat",
        "konfigurációs json",
        "kimeneti lemezkép neve",
        "Példák",
        "kiírás",
        "lementve"
    }
};
