//
// Created by root on 3/2/21.
//

#include "../../include/common/Thread.h"
#include "functional"

Thread::Thread()
{

}

Thread::~Thread()
{
    if (!this->isInterrupted())
    {
        this->interrupt();
    }

    if (this->th.joinable()) {
        this->th.join();
    }
}

void Thread::start()
{
    std::thread thr(std::bind(&Thread::run,this));
    this->th = std::move(thr);
}

std::thread::id Thread::getId()
{
    return this->th.get_id();
}

void Thread::interrupt()
{
    this->isInterript = true;
}

bool Thread::isInterrupted()
{
    return this->isInterript;
}

void Thread::join()
{
    this->th.join();
}

void Thread::run()
{

}
