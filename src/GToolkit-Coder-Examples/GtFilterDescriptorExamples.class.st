Class {
	#name : #GtFilterDescriptorExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters'
}

{ #category : #examples }
GtFilterDescriptorExamples >> filterDescriptorOffersCompletionValues [
	<gtExample>
	| aFilterDescriptor |
	
	aFilterDescriptor := self newFilterDescriptor
		offerCompletionValues: true;
		emptyDefaultValue: 'Lorem';
		completion: [ GtStreamedBlockCompletionStrategy new streamingBlock: [ :aText | (String loremIpsum piecesCutWhere: [:each :next | next = Character space]) asAsyncStream ] ].
	
	self assert: aFilterDescriptor name equals: 'No name'. 
	self assert: aFilterDescriptor order equals: 1. 
	self assert: (aFilterDescriptor completion isKindOf: GtStreamedBlockCompletionStrategy).
	self assert: aFilterDescriptor valueIsRequired.
	self assert: aFilterDescriptor isDefault.
	self assert: aFilterDescriptor emptyDefaultValue equals: 'Lorem'.
	self assert: aFilterDescriptor showAsDefaultWhenEmpty.
	self assert: aFilterDescriptor shouldOfferCompletionValues.
	
	self
		assert: (aFilterDescriptor newFilterWithValue: '')
		equals: GtSearchNullFilter new.
	
	^ aFilterDescriptor
]

{ #category : #examples }
GtFilterDescriptorExamples >> filterDescriptorValueNotRequired [
	<gtExample>
	| aFilterDescriptor |
	
	aFilterDescriptor := self newFilterDescriptor
		valueNotRequired.
	
	self assert: aFilterDescriptor name equals: 'No name'. 
	self assert: aFilterDescriptor order equals: 1. 
	self assert: aFilterDescriptor completion equals: nil.
	self assert: aFilterDescriptor valueIsRequired not.
	self assert: aFilterDescriptor isDefault.
	self assert: aFilterDescriptor emptyDefaultValue equals: nil.
	self assert: aFilterDescriptor showAsDefaultWhenEmpty.
	
	self
		assert: (aFilterDescriptor newFilterWithValue: '')
		equals: GtSearchNullFilter new.
	
	^ aFilterDescriptor
]

{ #category : #examples }
GtFilterDescriptorExamples >> newFilterDescriptor [
	<gtExample>
	| aFilterDescriptor |
	
	aFilterDescriptor := GtFilterDescriptor new.
	
	self assert: aFilterDescriptor name equals: 'No name'. 
	self assert: aFilterDescriptor order equals: 1. 
	self assert: aFilterDescriptor completion equals: nil.
	self assert: aFilterDescriptor valueIsRequired.
	self assert: aFilterDescriptor isDefault.
	self assert: aFilterDescriptor emptyDefaultValue equals: nil.
	self assert: aFilterDescriptor showAsDefaultWhenEmpty not.
	
	self
		assert: (aFilterDescriptor newFilterWithValue: '')
		equals: GtSearchNullFilter new.
	
	^ aFilterDescriptor
]
