"
!Behaviour's methods coder category look
Is intended to be applied on a method coder element when that method coder is within the context of a ==Behaviour== (class, trait, metaclass)
"
Class {
	#name : #GtBehaviorMethodCoderCategoryLook,
	#superclass : #GtMethodCoderCategoryLook,
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #'instance creation' }
GtBehaviorMethodCoderCategoryLook >> newTagsElementClass [
	^ GtBehaviorMethodCoderTagsElement
]
