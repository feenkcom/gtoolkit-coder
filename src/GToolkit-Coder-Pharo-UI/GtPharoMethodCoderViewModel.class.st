Class {
	#name : #GtPharoMethodCoderViewModel,
	#superclass : #GtSourceCoderViewModel,
	#instVars : [
		'savePreventors'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! View Models'
}

{ #category : #'api - actions' }
GtPharoMethodCoderViewModel >> allowSave [
	"Remove all save prventors and recompute the updated save availability"

	savePreventors removeAll.
	self notifySaveEnabled
]

{ #category : #'api - actions' }
GtPharoMethodCoderViewModel >> allowSaveDueTo: aSavePreventor [
	savePreventors
		remove: aSavePreventor
		ifAbsent: [ ^ self ].
		
	savePreventors
		ifNotEmpty: [ ^ self ].
		
	self notifySaveEnabled
]

{ #category : #'api - actions' }
GtPharoMethodCoderViewModel >> discardChanges [
	super discardChanges.
	self allowSave
]

{ #category : #accessing }
GtPharoMethodCoderViewModel >> elementClass [
	self coders
		ifNil: [ ^ GtExpandableMethodCoderElement ].

	^ self coders isForClass
		ifTrue: [ GtExpandableMethodCoderForBehaviorElement ]
		ifFalse: [ GtExpandableMethodCoderElement ]
]

{ #category : #'gt-extension' }
GtPharoMethodCoderViewModel >> gtInfo [
	^ super gtInfo, (Array streamContents: [ :aStream |
		aStream nextPut: (#saveEnabled -> self isSaveEnabled).
		self isSaveEnabled
			ifFalse: [ aStream nextPut: (#savePreventors -> savePreventors asArray) ] ])
]

{ #category : #initialization }
GtPharoMethodCoderViewModel >> initialize [
	super initialize.
	
	savePreventors := OrderedCollection new
]

{ #category : #testing }
GtPharoMethodCoderViewModel >> isSaveEnabled [
	^ savePreventors isEmpty
]

{ #category : #'private - notifying' }
GtPharoMethodCoderViewModel >> notifySaveDisabled [
	self announcerUIModel announce: (GtMethodCoderSaveDisabled new preventors: savePreventors asArray)
]

{ #category : #'private - notifying' }
GtPharoMethodCoderViewModel >> notifySaveEnabled [
	self announcerUIModel announce: (GtMethodCoderSaveEnabled new)
]

{ #category : #'api - actions' }
GtPharoMethodCoderViewModel >> preventSaveDueTo: aSavePreventor [
	(savePreventors includes: aSavePreventor)
		ifTrue: [ ^ self ].

	savePreventors add: aSavePreventor.

	savePreventors size > 1
		ifTrue: [ ^ self ].
		
	self notifySaveDisabled
]
