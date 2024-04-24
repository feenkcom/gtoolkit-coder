Class {
	#name : #GtCoderLocateDebuggerAction,
	#superclass : #GtCoderAction,
	#instVars : [
		'weakSpace'
	],
	#category : #'GToolkit-Coder-UI-Coder - Addons'
}

{ #category : #comparing }
GtCoderLocateDebuggerAction >> = anObject [
	^ super = anObject and: [ self space = anObject space ]
]

{ #category : #building }
GtCoderLocateDebuggerAction >> buildElementIn: aCoderActionsElement [
	^ aCoderActionsElement newLocateDebuggerButtonForAction: self
]

{ #category : #comparing }
GtCoderLocateDebuggerAction >> hash [
	^ super hash bitXor: self space hash
]

{ #category : #initialization }
GtCoderLocateDebuggerAction >> initialize [
	super initialize.

	self
		icon: BrGlamorousVectorIcons debug;
		title: 'Locate debugger';
		action: [ :aCoderViewModel :aButtonElement :anEvent |
			self locateDebuggerInSpace ]
]

{ #category : #'private - event handling' }
GtCoderLocateDebuggerAction >> locateDebuggerInSpace [
	^ self space ifNotNil: [ :theSpace | 
		| anArray xRandom yRandom |
		anArray := #(-10 -5 5 10).
		xRandom := anArray atRandom.
		yRandom := anArray atRandom.
		theSpace position: (theSpace position + (xRandom @ yRandom)) ]
]

{ #category : #accessing }
GtCoderLocateDebuggerAction >> space [
	^ weakSpace ifNotNil: [ :aWeak | aWeak at: 1 ]
]

{ #category : #accessing }
GtCoderLocateDebuggerAction >> weakSpace: anObject [
	weakSpace := anObject
]
