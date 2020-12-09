Class {
	#name : #GtMethodCoderUIModel,
	#superclass : #GtSourceCoderUIModel,
	#instVars : [
		'savePreventors'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method Model'
}

{ #category : #'api - actions' }
GtMethodCoderUIModel >> allowSave [
	"Remove all save prventors and recompute the updated save availability"

	savePreventors removeAll.
	self notifySaveEnabled
]

{ #category : #'api - actions' }
GtMethodCoderUIModel >> allowSaveDueTo: aSavePreventor [
	savePreventors
		remove: aSavePreventor
		ifAbsent: [ ^ self ].
		
	savePreventors
		ifNotEmpty: [ ^ self ].
		
	self notifySaveEnabled
]

{ #category : #'api - actions' }
GtMethodCoderUIModel >> discardChanges [
	super discardChanges.
	self allowSave
]

{ #category : #accessing }
GtMethodCoderUIModel >> elementClass [
	self coders
		ifNil: [ ^ GtExpandableMethodCoderElement ].

	^ self coders isForClass
		ifTrue: [ GtExpandableMethodCoderForBehaviorElement ]
		ifFalse: [ GtExpandableMethodCoderElement ]
]

{ #category : #'gt-extension' }
GtMethodCoderUIModel >> gtInfo [
	^ super gtInfo, (Array streamContents: [ :aStream |
		aStream nextPut: (#saveEnabled -> self isSaveEnabled).
		self isSaveEnabled
			ifFalse: [ aStream nextPut: (#savePreventors -> savePreventors asArray) ] ])
]

{ #category : #initialization }
GtMethodCoderUIModel >> initialize [
	super initialize.
	
	savePreventors := OrderedCollection new
]

{ #category : #testing }
GtMethodCoderUIModel >> isSaveEnabled [
	^ savePreventors isEmpty
]

{ #category : #'private - notifying' }
GtMethodCoderUIModel >> notifySaveDisabled [
	self announcerUIModel announce: (GtMethodCoderSaveDisabled new preventors: savePreventors asArray)
]

{ #category : #'private - notifying' }
GtMethodCoderUIModel >> notifySaveEnabled [
	self announcerUIModel announce: (GtMethodCoderSaveEnabled new)
]

{ #category : #'api - actions' }
GtMethodCoderUIModel >> preventSaveDueTo: aSavePreventor [
	(savePreventors includes: aSavePreventor)
		ifTrue: [ ^ self ].

	savePreventors add: aSavePreventor.

	savePreventors size > 1
		ifTrue: [ ^ self ].
		
	self notifySaveDisabled
]
