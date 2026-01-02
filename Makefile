TARGET := main

BUILD_DIR := ./build
INCLUDE_DIR := ./include
SOURCE_DIR := ./src
TEST_DIR := ./test

SRC := $(shell find $(SOURCE_DIR) -name *.cpp)
OBJ := $(SRC:%=build/%.o)
DEP := $(OBJ:.o=.d)

CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++20

all: $(BUILD_DIR)/main

$(BUILD_DIR)/$(TARGET): $(OBJ)
	$(CXX) $(OBJ) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -I $(INCLUDE_DIR) -c $< -o $@

.PHONY: test
test: $(BUILD_DIR)/test-all
	$(BUILD_DIR)/test-all

$(BUILD_DIR)/test-all: $(TEST_DIR)/test-all.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -I $(INCLUDE_DIR) -o $@ $<

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
