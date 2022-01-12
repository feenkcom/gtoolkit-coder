Extension { #name : #GtCoderModel }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asCoderViewModel [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asElement [
	^ self asCoderViewModel asElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asExpandedOnlyElement [
	"Create an element for just the expanded coder without expander"

	^ GtExpandedOnlyCoderElement new
		coderViewModel: self asCoderViewModel;
		yourself
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> coderLook [
	<return: #BrAptitude>

	^ (self attributeNamed: #coderLook ifAbsent: [ nil ]) value
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> coderLook: aLookOrBlock [
	self attributeNamed: #coderLook put: aLookOrBlock
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> elementClass [
	^ GtExpandableSourceCoderElement
]
