Class {
	#name : 'GtAsyncSearchGroupStream',
	#superclass : 'Object',
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'itemsStream',
		'itemsFuture',
		'filter',
		'scope'
	],
	#category : 'GToolkit-Coder-Filters - Streams'
}

{ #category : 'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithDefaultGroup
]

{ #category : 'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWithDefaultGroup [
	"The common type between the default group and any other group is the other group."
	^ self
]

{ #category : 'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWithGenericGroup [
	"The common type between a generic group and any other group is the other group."
	^ self
]

{ #category : 'as yet unclassified' }
GtAsyncSearchGroupStream class >> mergeTypeWithTypedGroup: aGroupType [
	^ self
]

{ #category : 'accessing' }
GtAsyncSearchGroupStream >> filter [
	^ filter
]

{ #category : 'initialization' }
GtAsyncSearchGroupStream >> forFilter: aFilter [
	self
		forFilter: aFilter
		scope: (aFilter 
			ifNil: [ AsyncEmptyStream new ]
			ifNotNil: [ aFilter defaultFilterScopeStream ])
]

{ #category : 'initialization' }
GtAsyncSearchGroupStream >> forFilter: aFilter scope: aScopeStream [
	filter := aFilter.
	scope := aScopeStream.
	self updateItems
]

{ #category : 'as yet unclassified' }
GtAsyncSearchGroupStream >> gtItemsFor: aView [
	<gtView>
	| anAnnouncer theItems aListView |
	
	anAnnouncer := Announcer new.
	theItems := nil.
	
	aListView := aView list.
	^ aListView
		title: 'Items' translated;
		priority: 10;
		items: [
			theItems ifNil: [
				self refreshItems.
				(itemsFuture map: [ :computedItems | computedItems collect: [ :each |  #item -> each ] ]) await
					onSuccessDo: [ :theLoadedItems |
						theItems := theLoadedItems.
						anAnnouncer announce: Announcement new ];
					onFailureDo: [ :anError | ] ].
			theItems ifNil: [ { #loading -> 'Loading..' } ] ];
		itemType: [ :anItemTypeFactory  :eachItem | eachItem key ];
		itemStencil: [ :anItemType |
			(anItemType = #item)
				ifTrue: [ aListView newItemLabel ]
				ifFalse: [
					BrLabel new
						alignCenter;
						hMatchParent;
						aptitude: (BrGlamorousLabelAptitude new italic; foreground: Color gray) ] ];
		itemDataBinder: [ :aLabel :anItem :anItemNode |
			| aText |
			aText := anItem value.
			aLabel text: aText gtDisplayText asRopedText. ];
		disableAsync;
		updateWhen: Announcement in: anAnnouncer
]

{ #category : 'accessing' }
GtAsyncSearchGroupStream >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : 'initialization' }
GtAsyncSearchGroupStream >> initialize [
	super initialize.

	itemsStream := AsyncEmptyStream new.
]

{ #category : 'api - stream' }
GtAsyncSearchGroupStream >> pollNext: anAsynchronousContext [
	"Attempt to pull out the next value of this stream, registering the current task for wakeup if the value is not yet available, and returning None if the stream is exhausted.
	There are several possible return values, each indicating a distinct stream state:
	 - Poll::Pending means that this stream's next value is not ready yet. Implementations will ensure that the current task will be notified when the next value may be ready.
	 - Poll::Ready(Some(val)) means that the stream has successfully produced a value, val, and may produce further values on subsequent poll_next calls.
	 - Poll::Ready(None) means that the stream has terminated, and poll_next should not be invoked again."
	<return: #AsyncPoll>

	^ itemsStream pollNext: anAsynchronousContext
]

{ #category : 'initialization' }
GtAsyncSearchGroupStream >> refreshItems [
	self forFilter: self filter
]

{ #category : 'accessing' }
GtAsyncSearchGroupStream >> scope [
	^ scope
]

{ #category : 'api - stream' }
GtAsyncSearchGroupStream >> sizeHint [
	<return: #AsyncStreamSizeHint>

	^ itemsStream sizeHint
]

{ #category : 'initialization' }
GtAsyncSearchGroupStream >> updateItems [
	itemsStream := scope filter: filter
]
