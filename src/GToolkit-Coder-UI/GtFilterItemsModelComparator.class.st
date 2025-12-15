Class {
	#name : #GtFilterItemsModelComparator,
	#superclass : #Object,
	#instVars : [
		'incomingItems',
		'existingItems'
	],
	#category : 'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #accessing }
GtFilterItemsModelComparator >> existingItems [
	^ existingItems
]

{ #category : #accessing }
GtFilterItemsModelComparator >> existingItems: anObject [
	existingItems := anObject
]

{ #category : #comparing }
GtFilterItemsModelComparator >> ifEqual: aBlock [
	existingItems size = incomingItems size ifFalse: [ ^ self ].
	
	existingItems with: incomingItems do: [ :anExisting :anIncoming |
		(anExisting equals: anIncoming) ifFalse: [ ^ self ] ].
		
	^ aBlock value
]

{ #category : #accessing }
GtFilterItemsModelComparator >> incomingItems [
	^ incomingItems
]

{ #category : #accessing }
GtFilterItemsModelComparator >> incomingItems: anObject [
	incomingItems := anObject
]
