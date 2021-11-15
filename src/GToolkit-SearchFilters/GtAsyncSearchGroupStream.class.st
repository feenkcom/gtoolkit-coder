Class {
	#name : #GtAsyncSearchGroupStream,
	#superclass : #Object,
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'itemsStream',
		'filter',
		'scope'
	],
	#category : #'GToolkit-SearchFilters-Results'
}

{ #category : #'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithDefaultGroup
]

{ #category : #'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWithDefaultGroup [
	"The common type between the default group and any other group is the other group."
	^ self
]

{ #category : #'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWithGenericGroup [
	"The common type between a generic group and any other group is the other group."
	^ self
]

{ #category : #'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWithTypedGroup: aGroupType [
	^ self
]

{ #category : #accessing }
GtAsyncSearchGroupStream >> filter [
	^ filter
]

{ #category : #'private - updating' }
GtAsyncSearchGroupStream >> filteredItemsStream [
	^ scope asyncSimilarCopy filter: filter
]

{ #category : #initialization }
GtAsyncSearchGroupStream >> forFilter: aFilter [
	self
		forFilter: aFilter
		scope: (aFilter 
			ifNil: [ AsyncEmptyStream new ]
			ifNotNil: [ aFilter defaultFilterScope ])
]

{ #category : #initialization }
GtAsyncSearchGroupStream >> forFilter: aFilter scope: aScopeStream [
	filter := aFilter.
	scope := aScopeStream.
	self updateItems
]

{ #category : #'gt - extensions' }
GtAsyncSearchGroupStream >> gtItemsFor: aView [
	<gtView>

	^ aView list
		title: 'Items' translated;
		priority: 10;
		items: [ self asyncSimilarCopy ]
]

{ #category : #'gt - extensions' }
GtAsyncSearchGroupStream >> gtMetricsFor: aView [
	<gtView>

	^ aView empty
]

{ #category : #accessing }
GtAsyncSearchGroupStream >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : #initialization }
GtAsyncSearchGroupStream >> initialize [
	super initialize.

	itemsStream := AsyncEmptyStream new
]

{ #category : #'api - stream' }
GtAsyncSearchGroupStream >> pollNext: anAsynchronousContext [
	"Attempt to pull out the next value of this stream, registering the current task for wakeup if the value is not yet available, and returning None if the stream is exhausted.
	There are several possible return values, each indicating a distinct stream state:
	 - Poll::Pending means that this stream's next value is not ready yet. Implementations will ensure that the current task will be notified when the next value may be ready.
	 - Poll::Ready(Some(val)) means that the stream has successfully produced a value, val, and may produce further values on subsequent poll_next calls.
	 - Poll::Ready(None) means that the stream has terminated, and poll_next should not be invoked again."
	<return: #AsyncPoll>

	^ itemsStream pollNext: anAsynchronousContext
]

{ #category : #'api - stream copy' }
GtAsyncSearchGroupStream >> postSimilarCopy [
	"Is called by similarCopy. self is a shallow copy, implementors should set the fields as necessary to complete the similar copy"
	scope := scope asyncSimilarCopy.
	self updateItems
]

{ #category : #'private - updating' }
GtAsyncSearchGroupStream >> refreshItems [
	self updateItems
]

{ #category : #accessing }
GtAsyncSearchGroupStream >> scope [
	^ scope
]

{ #category : #'api - stream' }
GtAsyncSearchGroupStream >> sizeHint [
	<return: #AsyncStreamSizeHint>

	^ itemsStream sizeHint
]

{ #category : #'private - updating' }
GtAsyncSearchGroupStream >> updateItems [
	itemsStream := self filteredItemsStream
]
