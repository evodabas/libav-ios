/*
 * This file is part of Libav.
 *
 * Libav is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * Libav is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with Libav; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#ifndef AVUTIL_ARM_CPU_H
#define AVUTIL_ARM_CPU_H

#include "config.h"
#include "libavutil/cpu.h"
#include "libavutil/cpu_internal.h"

#define have_armv5te(flags) CPUEXT(flags, ARMV5TE)
#define have_armv6(flags)   CPUEXT(flags, ARMV6)
#define have_armv6t2(flags) CPUEXT(flags, ARMV6T2)
#define have_vfp(flags)     CPUEXT(flags, VFP)
#define have_vfpv3(flags)   CPUEXT(flags, VFPV3)
#define have_neon(flags)    CPUEXT(flags, NEON)

/* Some functions use the 'setend' instruction which is deprecated on ARMv8
 * and serializing on some ARMv7 cores. This macro ensures such functions
 * are only enabled on ARMv6. */
#define have_setend(flags)                                              \
    (have_armv6(flags) && !(have_vfpv3(flags) || have_neon(flags)))

#endif /* AVUTIL_ARM_CPU_H */
