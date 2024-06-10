(princ (strcat "
					Author - Robert Stokłosa
					Available commands:
					CIRCLEATMIDDLE - draws a circle at the midpoint of each segment of the selected polyline. 
                                    The circle has a diameter of 1/10 of the length of the segment.
") )

(defun C:CIRCLEATMIDDLE (/ poly polyName polyAtt polyLen segLen circCenDist circCord circDia vertexLst pp pt)
    (setq   poly (entsel "\nSelect polyline: ")
            polyName (car poly)
            polyAtt (entget (car poly))
            polyLen (vla-get-length (vlax-ename->vla-object polyName))
    ) ;Saving the attributes and length of the selected polyline
    (foreach pp polyAtt
        (if (= (car pp) 10) ;A condition checks if the attribute contains coordinates (starts with code 10)
        (setq vertexLst (cons (cdr pp) vertexLst)) ;Saving coordinates to a list
        )
    ) ;A loop checks all attributes of the polyline
    (foreach pt vertexLst
        (setq   segLen (- polyLen (vlax-curve-getDistAtPoint polyName pt)) ;Calculating the length of polyline segment
                circCenDist (+ (vlax-curve-getDistAtPoint polyName pt) (/ segLen 2.0)) ;Calculating the distance to the center of the circle
                polyLen (vlax-curve-getDistAtPoint polyName pt) ;Overwriting the length to calculate the next segment
                circCord (vlax-curve-getPointAtDist polyName circCenDist) ;Calculating the coordinates for inserting the circle
                circDia (/ segLen 10.0) ;Calculating the diameter of circle
        )
        (if (> circDia 0) ;The condition checks if the diameter is greater than 0 in the case of open polylines
        (command "_.CIRCLE" circCord "_D" circDia) ;Drawing a circle
        )
    ) ;A loop that performs calculations for each segment of the polyline
)