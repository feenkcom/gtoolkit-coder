Class {
	#name : 'GtCompositeRenameAction',
	#superclass : 'GtRenameAction',
	#instVars : [
		'otherTextIntervals',
		'otherTextAttributes'
	],
	#category : 'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : 'private' }
GtCompositeRenameAction >> addLocations: intervals to: anEditor [
	self addLocations: intervals toText: anEditor text
]

{ #category : 'private' }
GtCompositeRenameAction >> addLocations: intervals toText: ropedText [
	otherTextIntervals
		at: ropedText
		put: (intervals asSortedCollection: [ :a :b | a first < b first ])
]

{ #category : 'private' }
GtCompositeRenameAction >> addRenameAttributes [
	super addRenameAttributes.
	self addRenameAttributesToOtherEditors
]

{ #category : 'private' }
GtCompositeRenameAction >> addRenameAttributesToOtherEditors [
	| size |
	size := self originalName size.
	size < 1
		ifTrue: [ ^ self ].
	self removeOtherAttributes.
	otherTextIntervals
		keysAndValuesDo: [ :text :intervals | 
			otherTextAttributes
				at: text
				put:
					(intervals
						collect: [ :each | 
							| attribute |
							attribute := GtRenamePreviewAttribute new
								action: self;
								text: (text from: each first to: each last).
							(text from: each first to: each last) attributes: {attribute}.
							attribute ]) ]
]

{ #category : 'initialize-release' }
GtCompositeRenameAction >> initialize [
	super initialize.
	otherTextIntervals := IdentityDictionary new.
	otherTextAttributes := IdentityDictionary new
]

{ #category : 'private' }
GtCompositeRenameAction >> removeAttributes [
	super removeAttributes.
	self removeOtherAttributes
]

{ #category : 'private' }
GtCompositeRenameAction >> removeOtherAttributes [
	otherTextAttributes
		keysDo:
			[ :text | text clearAttributes: [ :each | self isRenameAttribute: each ] ]
]

{ #category : 'private' }
GtCompositeRenameAction >> undoChanges [
	super undoChanges.
	self removeOtherAttributes
]

{ #category : 'actions' }
GtCompositeRenameAction >> updateName: blText [
	super updateName: blText.
	otherTextAttributes
		do: [ :attrs | attrs do: [ :each | each updateText: blText ] ]
]

{ #category : 'private' }
GtCompositeRenameAction >> updateOtherEditors [
	self newName = self originalName
		ifTrue: [ ^ self ].
	otherTextIntervals
		keysAndValuesDo: [ :text :intervals | 
			self
				updateText: text
				at: intervals
				attributes: (otherTextAttributes at: text) ]
]

{ #category : 'private' }
GtCompositeRenameAction >> updateSource [
	super updateSource.
	self updateOtherEditors
]
