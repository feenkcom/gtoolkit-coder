Class {
	#name : #GtFilterModelItemsBuilder,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #converting }
GtFilterModelItemsBuilder >> asFilterModelItemsBuilder [
	^ self
]

{ #category : #'api - instantiation' }
GtFilterModelItemsBuilder >> create [
	<return: #Collection of: #GtFilterModelItem>
	^ self subclassResponsibility
]

{ #category : #initialization }
GtFilterModelItemsBuilder >> filterModel: aFilterModel [
	"Subclasses may use it to trigger item updates or other activities"

	
]

{ #category : #accessing }
GtFilterModelItemsBuilder >> firstItemDo: aBlock [
	| aCollection |
	aCollection := self create.
	aCollection ifEmpty: [ ^ self ].
	aBlock cull: aCollection first
]

{ #category : #accessing }
GtFilterModelItemsBuilder >> lastItemDo: aBlock [
	| aCollection |
	aCollection := self create.
	aCollection ifEmpty: [ ^ self ].
	aBlock cull: aCollection last
]
