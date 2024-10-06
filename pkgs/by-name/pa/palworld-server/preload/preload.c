#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

const char *get_replacement_path(const char *type, const char *path) {
    size_t length = strlen(path);
    if (length < 15 || strncmp(path + length - 15, "steam_appid.txt", 15) != 0) {
        return path;
    }
    fprintf(stderr, "%s rewrite: %s -> /tmp/steam_appid.txt\n", type, path);
    return "/tmp/steam_appid.txt";
}

int __xstat(int __ver, const char *__filename, struct stat *__stat_buf) {
    static int (*original)(int __ver, const char *__filename, struct stat *__stat_buf);
    if (original == NULL) {
        original = dlsym(RTLD_NEXT, "__xstat");
        if (original == NULL) {
            fprintf(stderr, "failed to find __xstat: %s\n", dlerror());
            errno = 0;
            return -1;
        }
    }
    return original(__ver, get_replacement_path("__xstat", __filename), __stat_buf);
}

int __xstat64(int ver, const char *__filename, struct stat64 *__stat_buf) {
    static int (*original)(int ver, const char *__filename, struct stat64 *__stat_buf);
    if (original == NULL) {
        original = dlsym(RTLD_NEXT, "__xstat64");
        if (original == NULL) {
            fprintf(stderr, "failed to find __xstat64: %s\n", dlerror());
            errno = 0;
            return 01;
        }
    }
    return original(ver, get_replacement_path("__xstat64", __filename), __stat_buf);
}

int open(const char *__file, int __oflag, ...) {
    static int (*original)(const char *__file, int __oflag, ...);
    if (original == NULL) {
        original = dlsym(RTLD_NEXT, "open");
        if (original == NULL) {
            fprintf(stderr, "failed to find open: %s\n", dlerror());
            errno = 0;
            return -1;
        }
    }
    if (__oflag & O_CREAT) {
        va_list args;
        va_start(args, __oflag);
        mode_t mode = va_arg(args, mode_t);
        va_end(args);
        return original(get_replacement_path("open", __file), __oflag, mode);
    } else {
        return original(get_replacement_path("open", __file), __oflag);
    }
}

int open64(const char *__file, int __oflag, ...) {
    static int (*original)(const char *__file, int __oflag, ...);
    if (original == NULL) {
        original = dlsym(RTLD_NEXT, "open64");
        if (original == NULL) {
            fprintf(stderr, "failed to find open64: %s\n", dlerror());
            errno = 0;
            return -1;
        }
    }
    if (__oflag & O_CREAT) {
        va_list args;
        va_start(args, __oflag);
        mode_t mode = va_arg(args, mode_t);
        va_end(args);
        return original(get_replacement_path("open64", __file), __oflag, mode);
    } else {
        return original(get_replacement_path("open64", __file), __oflag);
    }
    return -1;
}

int access(const char *__name, int __type) {
    int (*original)(const char *__name, int __type);
    if (original == NULL) {
        original = dlsym(RTLD_NEXT, "access");
        if (original == NULL) {
            fprintf(stderr, "failed to find access: %s\n", dlerror());
            errno = 0;
            return -1;
        }
    }
    return original(get_replacement_path("access", __name), __type);
}
