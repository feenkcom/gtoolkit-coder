Class {
	#name : #GtBehaviorMethodCoderTagsElement,
	#superclass : #GtMethodCoderTagsElement,
	#instVars : [
		'classTag'
	],
	#category : #'GToolkit-Coder-Pharo-UI-! Views'
}

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> behaviorOtherSideName [
	^ self classTagStringForMeta: self methodCoderUIModel isMeta not
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> behaviorSideName [
	^ self classTagStringForMeta: self methodCoderUIModel isMeta
]

{ #category : #initialization }
GtBehaviorMethodCoderTagsElement >> buildTags [
	^ super buildTags, { classTag := self newClassTag }
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> classTagStringFor: aMethodCoderUIModel [
	<return: #String>

	^ self classTagStringForMeta: aMethodCoderUIModel isMeta
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> classTagStringForMeta: aBoolean [
	<return: #String>

	^ aBoolean
		ifTrue: [ 'class' ]
		ifFalse: [ 'instance' ]
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
		aptitude:
			BrGlamorousButtonWithLabelAptitude
				+
					(BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								beSmallSize;
								disable;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: self behaviorSideName ]
						content: [ BrButton new
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
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
