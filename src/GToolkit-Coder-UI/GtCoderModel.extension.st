Extension { #name : #GtCoderModel }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asCoderUIModel [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asElement [
	^ self elementClass new
		coderUIModel: self asCoderUIModel;
		yourself
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> coderLook [
	<return: #BrLook>

	^ (self attributeNamed: #coderLook ifAbsent: [ nil ]) value
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> coderLook: aLookOrBlock [
	self attributeNamed: #coderLook put: aLookOrBlock
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> elementClass [
	^ GtExpandableCoderElement
]
