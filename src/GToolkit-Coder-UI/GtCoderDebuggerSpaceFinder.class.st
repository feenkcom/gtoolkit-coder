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
		'process',
		'space'
	],
	#category : #'GToolkit-Coder-UI-Coders - Evaluation'
}

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
						ifFalse: [ aQuery anyOne debugSession interruptedProcess == process
								ifTrue: [ ^ space := eachSpace ] ] ] ].

	^ space
]

{ #category : #accessing }
GtCoderDebuggerSpaceFinder >> process [
	^ process
]

{ #category : #accessing }
GtCoderDebuggerSpaceFinder >> process: anObject [
	process := anObject
]

{ #category : #accessing }
GtCoderDebuggerSpaceFinder >> space [
	<return: #BlSpace or: nil>
	^ space
]
