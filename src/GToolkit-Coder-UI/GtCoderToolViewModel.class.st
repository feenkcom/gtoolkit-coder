Class {
	#name : #GtCoderToolViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'coderViewModelsStack',
		'announcer'
	],
	#category : #'GToolkit-Coder-UI-! Core - View Models'
}

{ #category : #announcer }
GtCoderToolViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'api - coder tool' }
GtCoderToolViewModel >> canGoBack [
	^ coderViewModelsStack size > 1
]

{ #category : #'api - coder tool' }
GtCoderToolViewModel >> currentCoderViewModel [
	<return: #GtSingleCoderViewModel>

	^ coderViewModelsStack top
]

{ #category : #'api - coder tool' }
GtCoderToolViewModel >> hasCoderViewModel [
	^ coderViewModelsStack isNotEmpty
]

{ #category : #initialization }
GtCoderToolViewModel >> initialize [
	super initialize.
	
	coderViewModelsStack := Stack new
]

{ #category : #'private - notifying' }
GtCoderToolViewModel >> notifyCoderViewModelPopped: aCoderViewModel [
	self announce: (GtCoderToolViewModelCoderPopped new coderViewModel: aCoderViewModel)
]

{ #category : #'private - notifying' }
GtCoderToolViewModel >> notifyCoderViewModelPushed: aCoderViewModel [
	self announce: (GtCoderToolViewModelCoderPushed new coderViewModel: aCoderViewModel)
]

{ #category : #'api - coder tool' }
GtCoderToolViewModel >> popCoderViewModel [
	| aPoppedCoder |
	
	self hasCoderViewModel
		ifFalse: [ ^ self ].
	
	aPoppedCoder := coderViewModelsStack pop.
	self notifyCoderViewModelPopped: aPoppedCoder
]

{ #category : #'api - coder tool' }
GtCoderToolViewModel >> pushCoderViewModel: aCoderViewModel [
	coderViewModelsStack push: aCoderViewModel.
	self notifyCoderViewModelPushed: aCoderViewModel
]
