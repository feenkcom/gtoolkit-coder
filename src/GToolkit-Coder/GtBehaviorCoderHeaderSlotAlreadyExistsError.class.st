Class {
	#name : #GtBehaviorCoderHeaderSlotAlreadyExistsError,
	#superclass : #GtBehaviorCoderHeaderSlotError,
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderSlotAlreadyExistsError >> description [
	^ 'Slot named {1} already exists in the definition' format: { self slotName }
]
