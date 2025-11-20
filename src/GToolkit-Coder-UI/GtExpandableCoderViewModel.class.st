Class {
	#name : #GtExpandableCoderViewModel,
	#superclass : #GtSingleCoderViewModel,
	#instVars : [
		'expanded',
		'shouldHaveHeader',
		'hasFocus'
	],
	#category : #'GToolkit-Coder-UI-Coder - Basic'
}

{ #category : #converting }
GtExpandableCoderViewModel >> asExpandedOnlyElement [
	"Create an element for just the expanded coder without expander"

	^ GtSourceCoderExpandedOnlyElement new
		textualCoderViewModel: self asCoderViewModel;
		yourself
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> collapse [
	self expanded: false
]

{ #category : #'api - text' }
GtExpandableCoderViewModel >> collapsedTextPromise [
	"Return a text that should be displayed in the collapsed state"
	<return: #TAsyncPromise of: #BlText>

	^ coderModel collapsedTextPromise
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expand [
	self expanded: true
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expanded [
	^ expanded
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expanded: aBoolean [
	self expanded: aBoolean from: self
]

{ #category : #'api - expansion' }
GtExpandableCoderViewModel >> expanded: aBoolean from: aSourceObject [
	expanded = aBoolean
		ifTrue: [ ^ self ].

	expanded := aBoolean.
	self notifyExpansionChanged: expanded from: aSourceObject
]

{ #category : #'api - focus' }
GtExpandableCoderViewModel >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - focus' }
GtExpandableCoderViewModel >> focused: aBoolean [
	self focused: aBoolean from: self
]

{ #category : #'api - focus' }
GtExpandableCoderViewModel >> focused: aBoolean from: aSourceObject [
	hasFocus = aBoolean
		ifTrue: [ ^ self ].

	hasFocus := aBoolean.
	self notifyFocusChanged: hasFocus from: aSourceObject.

	codersUIModel ifNotNil: [ :theCoders |
		aBoolean
			ifTrue: [ theCoders focusCoderUIModel: self  ]
			ifFalse: [ theCoders unfocusCoderUIModel: self ] ]
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> headerElementClass [
	"Return an class of an element that should represent a header of the coder.
	The used element must implement {{gtClass:TGtWithTextualCoderViewModel}} trait."
	<return: #TGtWithTextualCoderViewModel or: nil>

	^ nil
]

{ #category : #initialization }
GtExpandableCoderViewModel >> initialize [
	super initialize.
	expanded := true.
	hasFocus := false.
	shouldHaveHeader := true
]

{ #category : #'private - notifying' }
GtExpandableCoderViewModel >> notifyExpansionChanged: aBoolean from: aSourceObject [
	self
		announce: (GtExpandableCoderViewModelExpansionChanged new
				textualCoderViewModel: self;
				expanded: aBoolean;
				source: aSourceObject)
]

{ #category : #'private - notifying' }
GtExpandableCoderViewModel >> notifyFocusChanged: aBoolean from: aSourceObject [
	self announcer announce: (GtTextualCoderViewModelFocusChanged new 
		focused: aBoolean; 
		source: aSourceObject)
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> shouldHaveHeader: aBoolean [
	shouldHaveHeader := aBoolean
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> wantsHeader [
	<return: #Boolean>

	^ shouldHaveHeader and: [ self headerElementClass notNil ]
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> withHeader [
	self shouldHaveHeader: true
]

{ #category : #'api - header' }
GtExpandableCoderViewModel >> withoutHeader [
	self shouldHaveHeader: false
]
