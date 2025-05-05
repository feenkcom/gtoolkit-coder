Extension { #name : #GtMagritteViewModelExamples }

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> asyncViewModelWithSimpleBaseline [
	<gtExample>
	<return: #GtMagritteViewModel>
	| aViewModel anObject aDescription |
	anObject := self simpleBaselineObject.
	aDescription := self simpleBaselineDescription.
	aViewModel := GtMagritteViewModel forObject: anObject description: aDescription.

	self assert: aViewModel mementoFuture isAsyncFuture.

	^ aViewModel
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> asyncViewModelWithSimpleBaselines [
	<gtExample>
	<return: #GtMagritteViewModel>
	| aViewModel anObject aDescription |
	anObject := GtMagritteModelExamples new simpleBaselinesObject.
	aDescription := GtMagritteModelExamples new simpleBaselinesDescription.
	aViewModel := GtMagritteViewModel forObject: anObject description: aDescription.

	self assert: aViewModel mementoFuture isAsyncFuture.

	^ aViewModel
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> elementWithSimpleBaseline [
	<gtExample>
	<return: #BrFrame>
	| aViewModel anElement |
	aViewModel := self asyncViewModelWithSimpleBaseline.
	anElement := aViewModel asElement.

	self assert: anElement isNotNil.

	^ anElement
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> simpleBaselineDescription [
	<gtExample>
	<return: #MAPriorityContainer>
	^ GtMagritteModelExamples new simpleBaselineDescription
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> viewModelWithBaselines [
	<gtExample>
	<return: #GtMagritteViewModel>
	| aViewModel anObject aDescription |
	anObject := GtMagritteModelExamples new simpleBaselinesObject.
	aDescription := GtMagritteModelExamples new simpleBaselinesDescription.
	aViewModel := GtMagritteViewModel forObject: anObject description: aDescription.

	self assert: aViewModel mementoFuture isAsyncFuture.

	^ aViewModel
]

{ #category : #'*GToolkit-Coder-Examples' }
GtMagritteViewModelExamples >> viewModelWithBaselinesWithoutSaveOrCancelButton [
	<gtExample>
	<return: #GtMagritteViewModel>
	| aViewModel |
	aViewModel := self viewModelWithBaselines.

	aViewModel actions: #().

	^ aViewModel
]
