Class {
	#name : #GtCodersElement,
	#superclass : #BlElement,
	#instVars : [
		'coders',
		'listElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #converting }
GtCodersElement >> asVerticallyResizableDo: aBlock [
	^ self
]

{ #category : #ui }
GtCodersElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self listElement as: #codersList.
]

{ #category : #ui }
GtCodersElement >> buildElementForCoder: aCoder [
	^ aCoder asElement
]

{ #category : #accessing }
GtCodersElement >> coders [
	^ coders
]

{ #category : #accessing }
GtCodersElement >> coders: aCoders [
	coders := aCoders.
	self buildElement.
	coders announcer weak
		when: GtCodersCoderAdded , GtCodersCoderRemoved , GtCodersCodersChanged
		send: #updateList
		to: self
]

{ #category : #ui }
GtCodersElement >> listElement [
	| dataSource |
	dataSource := GtCodersDataSource new
		coders: coders;
		when: BlInfiniteDataSourceChanged
			do: [ listElement ifNotNil: #removeFromParent.
			self addChild: self listElement as: #codersList ];
		yourself.
	listElement := BlInfiniteElement new
		in: [ :e | 
			e
				layout:
					(BlInfiniteLinearLayout vertical
						infiniteElement: e;
						yourself) ];
		dataSource: dataSource;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		yourself.
	^ listElement
]

{ #category : #private }
GtCodersElement >> updateList [
	listElement dataSource updateCoders
]
