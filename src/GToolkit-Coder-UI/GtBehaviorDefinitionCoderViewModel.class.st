Class {
	#name : #GtBehaviorDefinitionCoderViewModel,
	#superclass : #GtSingleCoderViewModel,
	#instVars : [
		'foo'
	],
	#category : #'GToolkit-Coder-UI-Coder - Behavior-Definition Model'
}

{ #category : #accessing }
GtBehaviorDefinitionCoderViewModel >> elementClass [
	^ GtPharoBehaviorDefinitionCoderElement
]

{ #category : #accessing }
GtBehaviorDefinitionCoderViewModel >> onClassChanged: anAnnouncment [
	self announce: anAnnouncment
]

{ #category : #accessing }
GtBehaviorDefinitionCoderViewModel >> subscribeToCoderModel [
	super subscribeToCoderModel.
		
	self coderModel weak
		when: GtCoderClassChanged
		send: #onClassChanged:
		to: self
]