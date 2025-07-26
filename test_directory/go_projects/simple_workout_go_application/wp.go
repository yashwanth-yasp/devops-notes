package main

import (
	"fmt"
	"time"
)

type workoutPlan struct {
	Title    string
	Injuries []string
	Days     []workoutDay
}

type workoutDay struct {
	Day           string
	TargetMuscles string
	Workouts      []workout
}

type workout struct {
	Name string
	sets int
	reps int
}

func findTodaysWorkout(plan []workoutPlan, i int, day string) (w []workout) {
	// Check if the selected plan index is valid
	if i < 1 || i > len(plan) {
		fmt.Println("Invalid plan selection.")
		return
	}

	selectedPlan := plan[i-1] // Adjust index (1-based to 0-based)

	for _, d := range selectedPlan.Days {
		if d.Day == day {
			fmt.Println("\nToday's Workout for", selectedPlan.Title)
			fmt.Println("Target Muscles:", d.TargetMuscles)
			for _, workout := range d.Workouts {
				fmt.Printf("- %s: %d sets of %d reps\n", workout.Name, workout.sets, workout.reps)
			}
			return d.Workouts
		}
	}

	fmt.Println("\nNo workout scheduled for today.")
	return nil
}

func main() {
	// Define workout plans
	plans := []workoutPlan{
		{
			Title:    "Strength Training Plan",
			Injuries: []string{"Back Pain"},
			Days: []workoutDay{
				{
					Day:           "Monday",
					TargetMuscles: "Chest and Triceps",
					Workouts: []workout{
						{"Bench Press", 4, 10},
						{"Incline Dumbbell Press", 3, 12},
						{"Tricep Dips", 3, 15},
					},
				},
				{
					Day:           "Wednesday",
					TargetMuscles: "Back and Biceps",
					Workouts: []workout{
						{"Pull-ups", 4, 12},
						{"Barbell Rows", 3, 10},
						{"Bicep Curls", 3, 15},
					},
				},
				{
					Day:           "Friday",
					TargetMuscles: "Legs",
					Workouts: []workout{
						{"Squats", 4, 10},
						{"Lunges", 3, 12},
						{"Deadlifts", 3, 8},
					},
				},
			},
		},
		{
			Title:    "Cardio and Core Plan",
			Injuries: []string{"Knee Pain"},
			Days: []workoutDay{
				{
					Day:           "Tuesday",
					TargetMuscles: "Cardio and Core",
					Workouts: []workout{
						{"Running", 1, 30}, // 30 minutes
						{"Plank", 3, 60},   // 60 seconds
						{"Sit-ups", 3, 20},
					},
				},
				{
					Day:           "Thursday",
					TargetMuscles: "Cardio and Core",
					Workouts: []workout{
						{"Cycling", 1, 40}, // 40 minutes
						{"Russian Twists", 3, 30},
						{"Leg Raises", 3, 20},
					},
				},
			},
		},
	}

	// User selects a plan
	fmt.Print("Choose a Workout Plan (press 1 or 2):\n 1. Strength Training Plan \n 2. Cardio and Core Plan \n")
	var i int
	fmt.Scan(&i)

	// Get the current day
	currentTime := time.Now()
	today := currentTime.Weekday().String()

	// Find today's workout
	findTodaysWorkout(plans, i, today)
}
