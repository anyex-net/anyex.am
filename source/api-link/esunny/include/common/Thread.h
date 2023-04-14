//
// Created by root on 3/2/21.
//

#ifndef ESUNNYSERVER_THREAD_H
#define ESUNNYSERVER_THREAD_H


#include <thread>
#include <atomic>

class Thread {

public:
    Thread();
    virtual ~Thread();

    void start();
    std::thread::id getId();
    void interrupt();
    bool isInterrupted();
    void join();
    virtual void run();

private:
    std::atomic_bool isInterript{false};
    std::thread  th;
};


#endif //ESUNNYSERVER_THREAD_H
