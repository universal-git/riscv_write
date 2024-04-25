//Author: Subrata M. Brhaspatih
//just simple UART message
//No alloc
#![no_std]
#![no_main]

use core::arch::asm;
use core::panic::PanicInfo;
use core::usize;

const BASE_ADDR: usize = 0x1000_0000;

//use riscv_rt::entry;

mod boot {
    use core::arch::global_asm;
    global_asm!(
        r#".section .text._start
        .globl _start
        _start:"#,
        include_str!("sk_asm.S"),
    );
}

#[allow(dead_code)]
#[no_mangle]
pub extern "C" fn _main() -> ! {
    init();
    let mut loop_num = 0_u32;
    loop {
        loop_num += 1;
        let buff = b" Github\r\n";
        let buff1 = b"I met Jonathan at Github\r\n";
        let mut num_buff: [u8; 30] = [0;30];
        transformtobytes(loop_num as usize, &mut num_buff);
        write(&num_buff);
        write(buff);
        write(buff1);
        delay();
    }

}
fn delay() {
    for _ in 0..75000000 {                                      //delay 1s probably
        unsafe{asm!("nop")};
    }
}
#[allow(unused)]
fn transformtobytes(num: usize, buff: &mut [u8]) {
    let mut rem = num;
    let mut i = 0;
    while rem > 0 {
        buff[buff.len()-i-1] = ((rem % 10) + 48) as u8;
        rem = rem / 10;
        i +=1;
    }
}

fn write(buff: &[u8]) {
    let mut stat = 0_u32;
    for b in buff {
        while (stat & 0x60) != 0x60 {
            stat = unsafe {
                (core::ptr::read_volatile((BASE_ADDR + 0x114) as *mut u32)) & 0xff
            };
        }
        unsafe {
            core::ptr::write_volatile((BASE_ADDR + 0x100) as *mut u32, (*b) as u32);
            asm!("fence");
        }
        stat = 0_u32;
        while (stat & 0x20) != 0x20 {
            stat = unsafe {
                (core::ptr::read_volatile((BASE_ADDR + 0x114) as *mut u32)) & 0xff
            };
        }
    }
}

fn init() {
    unsafe {
        core::ptr::write_volatile((BASE_ADDR + 0x10c) as *mut u32, 0x83);
        core::ptr::write_volatile((BASE_ADDR + 0x100) as *mut u32, 0x36);
        core::ptr::write_volatile((BASE_ADDR + 0x104) as *mut u32, 0x0);
        asm!("fence");
        core::ptr::write_volatile((BASE_ADDR + 0x10c) as *mut u32, 0x03);
        core::ptr::write_volatile((BASE_ADDR + 0x104) as *mut u32, 0x00);
        asm!("fence");
    }
}


#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop{
        unsafe{asm!("nop");}
    }
}
