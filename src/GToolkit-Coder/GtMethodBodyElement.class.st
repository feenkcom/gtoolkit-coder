Class {
	#name : #GtMethodBodyElement,
	#superclass : #BlElement,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtMethodBodyElement >> initializeWith: aMethodCoder [
	| aSourceEditor anEditorElemenet completionStrategy completionController |

	methodCoder := aMethodCoder.

	aSourceEditor := methodCoder sourceEditor.

	anEditorElemenet := self newEditorElement.
	anEditorElemenet editor: aSourceEditor.

	methodCoder addBodyShortcutsTo: anEditorElemenet.

	completionStrategy := methodCoder createCompletionStrategy.

	completionController := GtCompletionController on: anEditorElemenet strategy: completionStrategy.
	completionController install.

	self addChild: anEditorElemenet
]

{ #category : #accessing }
GtMethodBodyElement >> methodCoder [
	^ methodCoder
]

{ #category : #'instance creation' }
GtMethodBodyElement >> newEditorElement [
	| anEditorElemenet |
	<return: #BrEditorElement>
	
	anEditorElemenet := BrEditorElement new.
	anEditorElemenet constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	^ anEditorElemenet
]
