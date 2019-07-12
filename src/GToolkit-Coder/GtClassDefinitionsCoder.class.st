Class {
	#name : #GtClassDefinitionsCoder,
	#superclass : #GtCoders,
	#instVars : [
		'class'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassDefinitionsCoder class >> forClass: aClass [
	^ self new
		forClass: aClass;
		yourself
]

{ #category : #adding }
GtClassDefinitionsCoder >> addDefinitionsForClass: aBehavior [
	self
		forItems:
			items
				,
					{aBehavior instanceSide.
					aBehavior classSide}.
	self updateCoders
]

{ #category : #elements }
GtClassDefinitionsCoder >> elementClass [
	^ GtCodersElement
]

{ #category : #'instance creation' }
GtClassDefinitionsCoder >> forClass: aBehavior [
	class := aBehavior.
	self
		forItems:
			{class instanceSide.
			class classSide}
]

{ #category : #'instance creation' }
GtClassDefinitionsCoder >> newCoderFor: aBehavior [
	^ (GtClassDefinitionCoder forClass: aBehavior)
		subscribeToSystem;
		yourself
]

{ #category : #adding }
GtClassDefinitionsCoder >> removeDefinitionsForClass: aBehavior [
	self
		forItems:
			(items
				reject: [ :e | 
					{aBehavior instanceSide.
					aBehavior classSide} includes: e ]).
	self updateCoders
]

{ #category : #updating }
GtClassDefinitionsCoder >> updateCoders [
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
