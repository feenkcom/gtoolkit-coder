"
Is sent when coder's source code changes


"
Class {
	#name : #GtCoderSourceCodeChanged,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'updateStragegy',
		'newText',
		'previousText',
		'reason'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #testing }
GtCoderSourceCodeChanged >> isSynchronous [
	^ self updateStrategy notNil
		and: [ self updateStrategy isSynchronous ]
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> newText [

	^ newText
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> newText: aText [

	newText := aText
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> previousText [
	^ previousText
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> previousText: aText [
	previousText := aText
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> reason [
	^ reason
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> reason: anObject [
	reason := anObject
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> source [
	^ self updateStrategy source
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> textEditCommand [
	^ self reason ifNotNil: [ :aReason|
		(aReason isKindOf: BrTextEditorModifiedEvent)
			ifTrue: [ aReason editCommand ]
			ifFalse: [ nil ] ]
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStrategy [
	^ updateStragegy
]

{ #category : #accessing }
GtCoderSourceCodeChanged >> updateStrategy: anUpdateStragegy [
	updateStragegy := anUpdateStragegy
]
