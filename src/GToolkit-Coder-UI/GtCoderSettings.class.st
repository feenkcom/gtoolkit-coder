Class {
	#name : #GtCoderSettings,
	#superclass : #Object,
	#classVars : [
		'DefaultDetailPositionState',
		'DefaultDetailState'
	],
	#category : 'GToolkit-Coder-UI-! Core'
}

{ #category : #settings }
GtCoderSettings class >> defaultDetailPositionState [
	<return: #GtPhlowToolDetailPositionState or: nil>
	^ DefaultDetailPositionState
]

{ #category : #settings }
GtCoderSettings class >> defaultDetailState [
	^ DefaultDetailState
]

{ #category : #settings }
GtCoderSettings class >> displayDetails [
	DefaultDetailState := GtPhlowToolDetailState detailed
]

{ #category : #settings }
GtCoderSettings class >> hideDetails [
	DefaultDetailState := nil
]

{ #category : #settings }
GtCoderSettings class >> leftPosition [
	DefaultDetailPositionState := nil
]

{ #category : #settings }
GtCoderSettings class >> topPosition [
	DefaultDetailPositionState := GtPhlowToolDetailPositionState top
]
