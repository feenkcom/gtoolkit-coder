Class {
	#name : #GtCompositeRenameAction,
	#superclass : #GtRenameAction,
	#instVars : [
		'otherTextIntervals',
		'otherTextAttributes'
	],
	#category : #'GToolkit-Coder-AddOns-Inline rename'
}

{ #category : #private }
GtCompositeRenameAction >> addLocations: intervals to: anEditor [
	otherTextIntervals
		at: anEditor
		put: (intervals asSortedCollection: [ :a :b | a first < b first ])
]

{ #category : #private }
GtCompositeRenameAction >> addRenameAttributes [
	super addRenameAttributes.
	self addRenameAttributesToOtherEditors
]

{ #category : #private }
GtCompositeRenameAction >> addRenameAttributesToOtherEditors [
	| size |
	size := self originalName size.
	size < 1 ifTrue: [ ^ self ].
	self removeOtherAttributes.
	otherTextIntervals
		keysAndValuesDo: [ :editor :intervals | 
			otherTextAttributes
				at: editor
				put: (intervals
						collect: [ :each | 
							| attribute |
							attribute := GtRenamePreviewAttribute new
									action: self;
									text: (editor text from: each first to: each last).
							(editor text from: each first to: each last) attributes: {attribute}.
							attribute ]) ]
]

{ #category : #'initialize-release' }
GtCompositeRenameAction >> initialize [
	super initialize.
	otherTextIntervals := IdentityDictionary new.
	otherTextAttributes := IdentityDictionary new
]

{ #category : #private }
GtCompositeRenameAction >> removeAttributes [
	super removeAttributes.
	self removeOtherAttributes
]

{ #category : #private }
GtCompositeRenameAction >> removeOtherAttributes [
	otherTextAttributes
		keysDo: [ :editor | editor text clearAttributes: [ :each | self isRenameAttribute: each ] ]
]

{ #category : #private }
GtCompositeRenameAction >> undoChanges [
	super undoChanges.
	self removeOtherAttributes
]

{ #category : #actions }
GtCompositeRenameAction >> updateName: blText [
	super updateName: blText.
	otherTextAttributes
		do: [ :attrs | attrs do: [ :each | each updateText: blText ] ]
]

{ #category : #private }
GtCompositeRenameAction >> updateOtherEditors [
	self newName = self originalName ifTrue: [ ^ self ].
	otherTextIntervals
		keysAndValuesDo: [ :editor :intervals | 
			| newText index |
			newText := '' asRopedText.
			index := 1.
			intervals
				with: (otherTextAttributes at: editor)
				do: [ :each :attr | 
					each first = 1
						ifTrue: [ newText := newText , attr text ]
						ifFalse: [ newText := newText , (editor text copyFrom: index to: each first - 1)
									, attr text ].
					index := each last + 1 ].
			index > editor text size
				ifFalse: [ newText := newText , (editor text copyFrom: index to: editor text size) ].
			editor text: newText ]
]

{ #category : #private }
GtCompositeRenameAction >> updateSource [
	super updateSource.
	self updateOtherEditors
]
