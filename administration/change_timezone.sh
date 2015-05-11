#!/bin/bash

change_timezone() {
  dpkg-reconfigure tzdata
}
