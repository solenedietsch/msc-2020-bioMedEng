 # -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 09:58:39 2020

@author: solen
"""
def evaluateNumber(number):
    if number % 15 == 0:
        return 'FizzBuzz'
    if number % 3 == 0 :
        return 'Fizz'
    if number % 5 == 0:
        return 'Buzz'
    return str(number)

def generate(minNumber,maxNumber):
    result = evaluateNumber(minNumber)
    counter = minNumber 

    while (counter < maxNumber):
        counter += 1
        result += evaluateNumber(counter)
        
    return result

def test_doNothing():
    return

def test_canCallgenerate():
    generate(1,1)

def test_shouldReturn1IfNumberIs1():
    assert generate(1,1) == '1'

def test_shouldReturn2IfNumberIs2():
    assert generate(2,2) == '2'

def test_shouldReturnFizzIfNumberIs3():
    assert generate(3,3) == 'Fizz'

def test_shouldReturnFizzIfNumberIs6():
    assert generate(6,6) == 'Fizz'

def test_shouldReturnBuzzIfNumberIs5():
    assert generate(5,5) == 'Buzz'    

def test_shouldReturnBuzzIfNumberIs10():
    assert generate(10,10) == 'Buzz'    

def test_shouldReturnFizzBuzzIfNumberIs15():
    assert generate(15,15) == 'FizzBuzz'

def test_shouldReturnFizzBuzzIfNumberIs30():
    assert generate(30,30) == 'FizzBuzz'

def test_shouldReturn12IfNumberAre1And2():
    assert generate(1,2) == '12'

def test_shouldReturn12FizzIfNumberAre1To3():
    assert generate(1,3) == '12Fizz'

def test_shouldReturnRelevantSequencesIfNumberAre1To3():
    assert generate(1,15) == '12Fizz4BuzzFizz78FizzBuzz11Fizz1314FizzBuzz'

print(generate(1,100))