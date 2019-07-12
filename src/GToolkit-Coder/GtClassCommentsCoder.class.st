Class {
	#name : #GtClassCommentsCoder,
	#superclass : #GtCoders,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassCommentsCoder class >> forClass: aClass [
	^ self new
		forClass: aClass instanceSide;
		yourself
]

{ #category : #adding }
GtClassCommentsCoder >> addCommentForClass: aClass [
	self forItems: items , {aClass}.
	self updateCoders
]

{ #category : #elements }
GtClassCommentsCoder >> elementClass [
	^ GtCodersElement
]

{ #category : #'instance creation' }
GtClassCommentsCoder >> forClass: aClass [
	class := aClass.
	self forItems: {class}
]

{ #category : #'instance creation' }
GtClassCommentsCoder >> newCoderFor: aClass [
	^ (GtClassCommentCoder forClass: aClass)
		subscribeToSystem;
		yourself
]

{ #category : #removing }
GtClassCommentsCoder >> removeCommentForClass: aClass [
	self forItems: (items reject: [ :e | e == aClass ]).
	self updateCoders
]

{ #category : #updating }
GtClassCommentsCoder >> updateCoders [
	| newCoders |
	newCoders := coders asOrderedCollection
		select: [ :each | each isModified ].
	items
		do: [ :each | 
			(newCoders anySatisfy: [ :coder | coder theClass = each ])
				ifFalse: [ newCoders add: (self newCoderFor: each) ] ].
	coders := newCoders.
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]
