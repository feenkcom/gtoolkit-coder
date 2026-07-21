Class {
	#name : #GtCoderViewModelCursorsChangedSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'textualCoderViewModel',
		'cursors',
		'source'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderViewModelCursorsChangedSignal >> cursors [
	^ cursors
]

{ #category : #accessing }
GtCoderViewModelCursorsChangedSignal >> cursors: anObject [
	cursors := anObject
]

{ #category : #accessing }
GtCoderViewModelCursorsChangedSignal >> source [
	^ source
]

{ #category : #accessing }
GtCoderViewModelCursorsChangedSignal >> source: anObject [
	source := anObject
]

{ #category : #accessing }
GtCoderViewModelCursorsChangedSignal >> textualCoderViewModel [
	^ textualCoderViewModel
]

{ #category : #accessing }
GtCoderViewModelCursorsChangedSignal >> textualCoderViewModel: anObject [
	textualCoderViewModel := anObject
]
