Class {
	#name : #GtMethodCoderTaskExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Basic'
}

{ #category : #private }
GtMethodCoderTaskExamples >> waitForTasks [
	self waitForTasks: 1000
]

{ #category : #private }
GtMethodCoderTaskExamples >> waitForTasks: milliseconds [
	| delay startTime |
	startTime := Time millisecondClockValue.
	delay := Delay forMilliseconds: 5.
	[ BlTktWorkerProvider highUICPUBoundPool isFree not
		and: [ startTime + milliseconds > Time millisecondClockValue ] ]
		whileTrue: [ delay wait ]
]
