Class {
	#name : #GtBehaviorMethodCoderTagsElement,
	#superclass : #GtMethodCoderTagsElement,
	#instVars : [
		'classTag'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> behaviorOtherSideName [
	^ self classTagStringForMeta: (self isMeta: self methodCoderUIModel) not
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> behaviorSideName [
	^ self classTagStringForMeta: (self isMeta: self methodCoderUIModel)
]

{ #category : #initialization }
GtBehaviorMethodCoderTagsElement >> buildTags [
	^ super buildTags, { classTag := self newClassTag }
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> classTagStringFor: aMethodCoderUIModel [
	<return: #String>

	^ self classTagStringForMeta: (self isMeta: aMethodCoderUIModel)
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> classTagStringForMeta: aBoolean [
	<return: #String>

	^ aBoolean
		ifTrue: [ 'class' ]
		ifFalse: [ 'instance' ]
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> isMeta: aMethodCoderUIModel [
	<return: #String>

	^ aMethodCoderUIModel coder behavior isMeta
]

{ #category : #accessing }
GtBehaviorMethodCoderTagsElement >> methodCoderUIModel: aMethodCoderUIModel [
	super methodCoderUIModel: aMethodCoderUIModel.

	isEditable
		ifTrue: [
			classTag label: (self classTagStringFor: aMethodCoderUIModel).
			classTag enabled: self methodCoderUIModel coder canMoveMethodToInstanceOrClass ]
		ifFalse: [ classTag text: (self classTagStringFor: aMethodCoderUIModel) ]
	
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newClassTag [
	^ isEditable
		ifTrue: [ self newEditableClassTag ]
		ifFalse: [ self newReadonlyClassTag ]
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newEditableClassTag [	
	^ BrButton new
		beTiny;
		look: BrGlamorousButtonWithLabelLook + (BrGlamorousWithDropdownLook
			handle: [
				BrButton new
					beSmall;
					disable;
					look: BrGlamorousButtonRectangularLook + BrGlamorousButtonLabelLook;
					label: self behaviorSideName ]
			content: [
				BrButton new
					beSmall;
					look: BrGlamorousButtonRectangularLook + BrGlamorousButtonLabelLook;
					label: self behaviorOtherSideName;
					action: [ :aButton |
						aButton fireEvent: (BrDropdownHideWish new).
						self methodCoderUIModel coder moveMethodToInstanceOrClass.
						classTag label: self behaviorSideName ] ])
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newReadonlyClassTag [
	<return: #BlElement>

	^ self newTag
]
