"
I find a {{gtClass:BlSpace}} in which a {{gtClass:GtMoldableDebugger}} for a given {{gtClass:Process}} is opened.
Main methods:
- {{gtMethod:GtCoderDebuggerSpaceFinder >> #process: | label=#selector}} sets the {{gtClass:Process}} for which a corresponding {{gtClass:BlSpace}} should be found,
- {{gtMethod:GtCoderDebuggerSpaceFinder >> #find | label=#selector}} searches the corresponding {{gtClass:BlSpace}}, 
- {{gtMethod:GtCoderDebuggerSpaceFinder >> #space | label=#selector}} returns the found {{gtClass:BlSpace}} or `nil`. 

"
Class {
	#name : #GtCoderDebuggerSpaceFinder,
	#superclass : #Object,
	#instVars : [
		'space',
		'debuggerMatcher'
	],
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

{ #category : #accessing }
GtCoderDebuggerSpaceFinder >> debugSession: aDebugSession [
	debuggerMatcher := GtCoderDebugSessionMatcher new debugSession: aDebugSession
]

{ #category : #finding }
GtCoderDebuggerSpaceFinder >> find [
	<return: #BlSpace or: nil>
	BlParallelUniverse all
		do: [ :eachUniverse | 
			eachUniverse spaces
				do: [ :eachSpace | 
					| aQuery |
					aQuery := eachSpace root query // GtMoldableDebugger.
					aQuery isEmpty
						ifFalse: [ (debuggerMatcher isMoldableDebugger: aQuery anyOne)
								ifTrue: [ ^ space := eachSpace ] ] ] ].

	^ space
]

{ #category : #initialization }
GtCoderDebuggerSpaceFinder >> initialize [
	super initialize.
	debuggerMatcher := GtCoderDebuggerMatcher new
]

{ #category : #accessing }
GtCoderDebuggerSpaceFinder >> process: aProcess [
	debuggerMatcher := GtCoderDebuggerInterruptedProcessMatcher new process: aProcess
]

{ #category : #accessing }
GtCoderDebuggerSpaceFinder >> space [
	<return: #BlSpace or: nil>
	^ space
]
