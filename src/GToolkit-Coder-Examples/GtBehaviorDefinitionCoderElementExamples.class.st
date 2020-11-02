Class {
	#name : #GtBehaviorDefinitionCoderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Coders - UI'
}

{ #category : #'examples - instance creation' }
GtBehaviorDefinitionCoderElementExamples >> forClassElement [
	<gtExample>
	| aCoderUIModel aCoderElement |

	aCoderUIModel := self forClassUIModel.
	aCoderElement := aCoderUIModel asElement.
	
	self assert: aCoderElement isExpanded not. 

	^ aCoderElement
]

{ #category : #'examples - instance creation' }
GtBehaviorDefinitionCoderElementExamples >> forClassUIModel [
	<gtExample>
	| aCoder aCoderUIModel |

	aCoder := GtBehaviorDefinitionCoderExamples new forClass.
	aCoderUIModel := aCoder asCoderUIModel.

	self assert: aCoderUIModel coder equals: aCoder.

	^ aCoderUIModel
]

{ #category : #'examples - instance creation' }
GtBehaviorDefinitionCoderElementExamples >> forMetaclassElement [
	<gtExample>
	| aCoderUIModel aCoderElement |

	aCoderUIModel := self forMetaclassUIModel.
	aCoderElement := aCoderUIModel asElement.
	
	self assert: aCoderElement isExpanded not. 

	^ aCoderElement
]

{ #category : #'examples - instance creation' }
GtBehaviorDefinitionCoderElementExamples >> forMetaclassUIModel [
	<gtExample>
	| aCoder aCoderUIModel |

	aCoder := GtBehaviorDefinitionCoderExamples new forMetaclass.
	aCoderUIModel := aCoder asCoderUIModel.

	self assert: aCoderUIModel coder equals: aCoder.

	^ aCoderUIModel
]

{ #category : #'examples - instance creation' }
GtBehaviorDefinitionCoderElementExamples >> forTraitElement [
	<gtExample>
	| aCoderUIModel aCoderElement |

	aCoderUIModel := self forTraitUIModel.
	aCoderElement := aCoderUIModel asElement.
	
	self assert: aCoderElement isExpanded not. 

	^ aCoderElement
]

{ #category : #'examples - instance creation' }
GtBehaviorDefinitionCoderElementExamples >> forTraitUIModel [
	<gtExample>
	| aCoder aCoderUIModel |

	aCoder := GtBehaviorDefinitionCoderExamples new forTrait.
	aCoderUIModel := aCoder asCoderUIModel.

	self assert: aCoderUIModel coder equals: aCoder.

	^ aCoderUIModel
]
