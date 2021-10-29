Class {
	#name : #GtCodersCodersChanged,
	#superclass : #GtCodersAnnouncement,
	#instVars : [
		'newCoders',
		'oldCoders'
	],
	#category : #'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCodersCodersChanged >> addedCoders [

	^ self newCoders reject: [ :aCoder | 
		self oldCoders identityIncludes: aCoder ]
]

{ #category : #accessing }
GtCodersCodersChanged >> newCoders [
	^ newCoders
]

{ #category : #accessing }
GtCodersCodersChanged >> newCoders: aCollection [

	self
		assert: [ aCollection isNotNil ]
		description: [ 'New coders collection must be non-nil' ].

	newCoders := aCollection
]

{ #category : #accessing }
GtCodersCodersChanged >> oldCoders [

	^ oldCoders
]

{ #category : #accessing }
GtCodersCodersChanged >> oldCoders: aCollection [

	self
		assert: [ aCollection isNotNil ]
		description: [ 'Old coders collection must be non-nil' ].

	oldCoders := aCollection
]

{ #category : #accessing }
GtCodersCodersChanged >> removedCoders [

	^ self oldCoders reject: [ :aCoder | 
		self newCoders identityIncludes: aCoder ]
]
