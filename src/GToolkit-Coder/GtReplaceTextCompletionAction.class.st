Class {
	#name : #GtReplaceTextCompletionAction,
	#superclass : #GtCompletionAction,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #'instance creation' }
GtReplaceTextCompletionAction class >> forText: aString [
	^ (self labeled: aString)
		text: aString;
		yourself
]

{ #category : #comparing }
GtReplaceTextCompletionAction >> = anObject [
	^ super = anObject and: [ self text = anObject text ]
]

{ #category : #executing }
GtReplaceTextCompletionAction >> finishCompletionOn: aCompletionController moveCursor: aBoolean [
	aCompletionController textEditor deleter
		from: 0 to: aCompletionController textEditor text size;
		delete.
	aCompletionController textEditor inserter
		string: text;
		at: 0;
		insert
]

{ #category : #comparing }
GtReplaceTextCompletionAction >> hash [
	^ super hash bitXor: text hash
]

{ #category : #executing }
GtReplaceTextCompletionAction >> previewOn: aCompletionController [
]

{ #category : #accessing }
GtReplaceTextCompletionAction >> text [
	^ text
]

{ #category : #accessing }
GtReplaceTextCompletionAction >> text: anObject [
	text := anObject
]

{ #category : #executing }
GtReplaceTextCompletionAction >> undoPreviewOn: aCompletionController [
]
