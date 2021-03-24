Class {
	#name : #GtPharoDummyDebugger,
	#superclass : #GtPharoDummy,
	#instVars : [
		'debugSession',
		'fullView',
		'receiver',
		'sourceCode',
		'method'
	],
	#category : #'GToolkit-Coder-Pharo-Examples-Dummies'
}

{ #category : #'instance creation' }
GtPharoDummyDebugger class >> useDuring: aBlock [
	| aDummyDebugger aPreviousDebugger |
	
	aDummyDebugger := self new.
	aPreviousDebugger := Smalltalk tools debuggerTool.
	
	[ 
		Smalltalk tools debuggerTool: aDummyDebugger.
		aBlock value
	] ensure: [
		Smalltalk tools debuggerTool: aPreviousDebugger.
		Smalltalk tools debuggers remove: aDummyDebugger ifAbsent: [  ] ].

	^ aDummyDebugger
]

{ #category : #accessing }
GtPharoDummyDebugger >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtPharoDummyDebugger >> fullView [
	^ fullView
]

{ #category : #testing }
GtPharoDummyDebugger >> isObsolete [
	^ true
]

{ #category : #accessing }
GtPharoDummyDebugger >> method [
	^ method
]

{ #category : #'opening api' }
GtPharoDummyDebugger >> openOn: aDebugSession withFullView: isFullView [
	debugSession := aDebugSession.
	fullView := isFullView.
	
	receiver := debugSession interruptedContext receiver.
	method := debugSession interruptedContext method.
	sourceCode := debugSession interruptedContext sourceNode sourceCode.

	debugSession terminate
]

{ #category : #accessing }
GtPharoDummyDebugger >> receiver [
	^ receiver
]

{ #category : #accessing }
GtPharoDummyDebugger >> sourceCode [
	^ sourceCode
]
