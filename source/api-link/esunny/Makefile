CXX		  := g++
CXX_FLAGS := -w -Wextra -std=c++11 -pthread -ggdb -g

SRC := source
BIN := bin
INCLUDES	:= -I/usr/include/mysql -Iinclude/common -Iinclude/esunny -Iinclude/quote -Iinclude/trade
LIBS		:= -L/usr/lib64/mysql -Llib

LIBRARIES	:=-lcrypto -lssl -lTapQuoteAPI -liTapTradeAPI -lmysqlclient

EXECUTABLE	:= esunnyServer

# 如果在没有指定任何目标的情况下运行make,它将执行它在Makefile中找到的第一个目标.按照惯例all是这样一个目标的名称.
all: $(BIN)/$(EXECUTABLE)

run: clean all
	clear
	./$(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE): source/main.cpp $(SRC)/*/*cpp
	$(CXX) $(CXX_FLAGS) ${INCLUDES} ${LIBS} $^ -o $@ $(LIBRARIES)

clean:
	-rm $(BIN)/*