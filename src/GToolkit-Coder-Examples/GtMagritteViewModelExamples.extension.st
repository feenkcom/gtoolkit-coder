Extension { #name : #GtMagritteViewModelExamples }

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> asyncViewModelWithSimpleBaseline [

	<gtExample>
	| aViewModel anObject aDescription |
	anObject := self simpleBaselineObject.
	aDescription := self simpleBaselineDescription.
	aViewModel := GtMagritteViewModel
		              forObject: anObject
		              description: aDescription.

	self assert: aViewModel mementoFuture isAsyncFuture.

	^ aViewModel
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> asyncViewModelWithSimpleBaselines [

	<gtExample>
	| aViewModel anObject aDescription |
	anObject := GtMagritteModelExamples new simpleBaselinesObject.
	aDescription := GtMagritteModelExamples new
		                simpleBaselinesDescription.
	aViewModel := GtMagritteViewModel
		              forObject: anObject
		              description: aDescription.

	self assert: aViewModel mementoFuture isAsyncFuture.

	^ aViewModel
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> elementWithSimpleBaseline [

	<gtExample>
	| aViewModel anElement |
	aViewModel := self asyncViewModelWithSimpleBaseline.
	anElement := aViewModel asElement.
	
	self assert: anElement isNotNil.

	^ anElement
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> simpleBaselineDescription [

	<gtExample>
	^ GtMagritteModelExamples new simpleBaselineDescription
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> viewModelWithBaselines [

	<gtExample>
	| aViewModel anObject aDescription |
	anObject := GtMagritteModelExamples new simpleBaselinesObject.
	aDescription := GtMagritteModelExamples new
		                simpleBaselinesDescription.
	aViewModel := GtMagritteViewModel
		              forObject: anObject
		              description: aDescription.

	self assert: aViewModel mementoFuture isAsyncFuture.

	^ aViewModel
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> viewModelWithBaselinesWithoutSaveOrCancelButton [
	<gtExample>
	| aViewModel |
	aViewModel := self viewModelWithBaselines.

	aViewModel actions: #().

	^ aViewModel
]
