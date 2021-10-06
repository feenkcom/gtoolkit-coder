Extension { #name : #GtCoderModel }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asCoderUIModel [
	^ self subclassResponsibility
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asCoderViewModel [
	^ self asCoderUIModel
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asElement [
	^ self asCoderUIModel asElement
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> asExpandedOnlyElement [
	"Create an element for just the expanded coder without expander"

	^ GtExpandedOnlyCoderElement new
		coderUIModel: self asCoderUIModel;
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
GtCoderModel >> defaultCoderLook [
	^ nil
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderModel >> elementClass [
	^ GtExpandableSourceCoderElement
]
