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

	self updateBehaviorSideButton
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newClassTag [
	^ BrButton new
		beTinySize;
		look:
			BrGlamorousButtonWithLabelLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								beSmallSize;
								disable;
								look: BrGlamorousButtonRectangularLook + BrGlamorousButtonLabelLook;
								label: self behaviorSideName ]
						content: [ BrButton new
								beSmallSize;
								look: BrGlamorousButtonRectangularLook + BrGlamorousButtonLabelLook;
								label: self behaviorOtherSideName;
								action: [ :aButton | 
									aButton fireEvent: BrDropdownHideWish new.
									self methodCoderUIModel coder moveMethodToInstanceOrClass.
									classTag label: self behaviorSideName ] ])
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> updateBehaviorSideButton [
	classTag label: (self classTagStringFor: self methodCoderUIModel).
	classTag enabled: self methodCoderUIModel coder canMoveMethodToInstanceOrClass
]
