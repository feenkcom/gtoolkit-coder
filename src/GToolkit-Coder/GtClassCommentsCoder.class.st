Class {
	#name : #GtClassCommentsCoder,
	#superclass : #GtCoders,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder'
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
GtClassCommentsCoder >> forClass: aBehavior [
	self flag: 'FIXME should listen class definition change'.
	class := aBehavior.
	self forItems: {class}
]

{ #category : #'instance creation' }
GtClassCommentsCoder >> newCoderFor: aBehavior [
	self flag: 'FIXME use other element'.
	^ GtMethodCoder forMethod: ProtoObject >> #initialize
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
			(newCoders anySatisfy: [ :coder | coder classOrMetaClass = each ])
				ifFalse: [ newCoders add: (self newCoderFor: each) ] ].
	coders := newCoders.
	self
		announce:
			(GtCodersCodersChanged new
				coders: self;
				yourself)
]
